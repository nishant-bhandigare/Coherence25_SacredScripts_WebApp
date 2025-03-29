import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_nest/theme_notifier.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                ProfileHeader(),
                SizedBox(height: 10),
                OverviewSection(),
                SizedBox(height: 20),
                TransactionList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeNotifier>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: themeData.getTheme() == themeData.darkTheme
            ? Colors.white12
            : Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: grey.withOpacity(0.03),
            spreadRadius: 10,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const HeaderIcons(),
            const SizedBox(height: 15),
            ProfileInfo(size: size),
            const SizedBox(height: 50),
            const FinancialSummary(),
          ],
        ),
      ),
    );
  }
}

class HeaderIcons extends StatelessWidget {
  const HeaderIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.bar_chart),
        Icon(Icons.more_vert),
      ],
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final Size size;
  const ProfileInfo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1531256456869-ce942a665e80?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTI4fHxwcm9maWxlfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: (size.width - 40) * 0.6,
          child: const Column(
            children: [
              Text(
                "Thomas",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainFontColor),
              ),
              SizedBox(height: 10),
              Text(
                "Software Developer",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FinancialSummary extends StatelessWidget {
  const FinancialSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FinancialItem(amount: "\$8900", label: "Income"),
        DividerWidget(),
        FinancialItem(amount: "\$5500", label: "Expenses"),
        DividerWidget(),
        FinancialItem(amount: "\$890", label: "Loan"),
      ],
    );
  }
}

class FinancialItem extends StatelessWidget {
  final String amount;
  final String label;

  const FinancialItem({super.key, required this.amount, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: mainFontColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w100,
            color: black,
          ),
        ),
      ],
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 40,
      color: black.withOpacity(0.3),
    );
  }
}

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Send Money',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('See all'),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        children: [
          TransactionItem(
            icon: Icons.arrow_upward_rounded,
            title: "Sent",
            description: "Sending Payment to Clients",
            amount: "\$150",
          ),
          SizedBox(height: 5),
          TransactionItem(
            icon: Icons.arrow_downward_rounded,
            title: "Receive",
            description: "Receiving Payment from company",
            amount: "\$250",
          ),
          SizedBox(height: 5),
          TransactionItem(
            icon: CupertinoIcons.money_dollar,
            title: "Loan",
            description: "Loan for the Car",
            amount: "\$400",
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String amount;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {

    final themeData = Provider.of<ThemeNotifier>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: themeData.getTheme() == themeData.darkTheme
            ? Colors.white12
            : Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: grey.withOpacity(0.03),
            spreadRadius: 10,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: arrowbgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(icon, color: Colors.black),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
